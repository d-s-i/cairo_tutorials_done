%builtins output range_check

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.dict import DictAccess
from starkware.cairo.common.squash_dict import squash_dict
from starkware.cairo.common.alloc import alloc

struct Location:
    member row: felt
    member column: felt
end

func verify_location_valid(loc: Location*):
    tempvar row = loc.row
    assert row * (row - 1) * (row - 2) * (row - 3) = 0

    tempvar column = loc.column
    assert column * (column - 1) * (column - 2) * (column - 3) = 0

    return ()
end

func verify_adjascent(loc0: Location*, loc1: Location*):
    alloc_locals
    local row_diff = loc0.row - loc1.row
    local column_diff = loc0.column - loc1.column

    if row_diff == 0:
        assert column_diff * column_diff = 1
        return ()
    else:
        assert column_diff = 0
        assert row_diff * row_diff = 1
        return ()
    end
end

func verify_location_list(loc_list: Location*, steps):
    verify_location_valid(loc=loc_list)
    if steps == 0:
        assert loc_list.row = 3
        assert loc_list.column = 3
        return ()
    end

    verify_adjascent(loc0=loc_list, loc1=loc_list + Location.SIZE)

    # Call verify_location_list recursively.
    verify_location_list(loc_list=loc_list + Location.SIZE, steps=steps - 1)

    return ()
end

func build_dict(
    loc_list: Location*,
    tile_list: felt*,
    steps,
    dict: DictAccess*
) -> (dict: DictAccess*):
    if steps == 0:
        return (dict=dict)
    end

    assert dict.key = [tile_list]

    let next_loc: Location* = loc_list + Location.SIZE
    assert dict.prev_value = 4 * next_loc.row + next_loc.column
    assert dict.new_value = 4 * loc_list.row + loc_list.column

    return build_dict(
        loc_list=next_loc,
        tile_list=tile_list + 1,
        steps=steps - 1,
        dict=dict + DictAccess.SIZE
    )
end

func finalize_state(
    dict: DictAccess*,
    index
) -> (dict : DictAccess*):
    if index == 0:
        return (dict=dict)
    end

    assert dict.key = index
    assert dict.prev_value = index - 1
    assert dict.new_value = index - 1

    return finalize_state(dict=dict + DictAccess.SIZE, index=index - 1)
end

func output_initial_values{output_ptr: felt*}(
    squashed_dict: DictAccess*,
    n: felt
):
    if n == 0:
        return ()
    end

    serialize_word(squashed_dict.new_value)

    return output_initial_values(squashed_dict=squashed_dict + DictAccess.SIZE, n=n - 1)
end

func check_solution{output_ptr : felt*, range_check_ptr}(
    loc_list: Location*, 
    tile_list: felt*, 
    steps: felt
):
    alloc_locals
    verify_location_list(loc_list=loc_list, steps=steps)

        # Allocate memory for the dict and the squashed dict.
    let (local dict_start : DictAccess*) = alloc()
    let (local squashed_dict : DictAccess*) = alloc()

    let (dict_end) = build_dict(
        loc_list=loc_list,
        tile_list=tile_list,
        steps=steps,
        dict=dict_start 
    )

    let (dict_end) = finalize_state(dict=dict_end, index=15)
    
    let (squashed_dict_end : DictAccess*) = squash_dict(
        dict_accesses=dict_start,
        dict_accesses_end=dict_end,
        squashed_dict=squashed_dict)

    # Store range_check_ptr in a local variable to make it
    # accessible after the call to output_initial_values().
    local range_check_ptr = range_check_ptr

        # Verify that the squashed dict has exactly 15 entries.
    # This will guarantee that all the values in the tile list
    # are in the range 1-15.
    assert squashed_dict_end - squashed_dict = 15 *
        DictAccess.SIZE

    output_initial_values(squashed_dict=squashed_dict, n=15)

    # Output the initial location of the empty tile.
    serialize_word(4 * loc_list.row + loc_list.column)

    # Output the number of steps.
    serialize_word(steps)

    return ()
end

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals
    local loc_tuple : (Location, Location, Location, Location, Location) = (
        Location(row=0, column=2),
        Location(row=1, column=2),
        Location(row=1, column=3),
        Location(row=2, column=3),
        Location(row=3, column=3)
    )

    local tiles : (felt, felt, felt, felt) = (3, 7, 8, 12)

    # Get the value of the frame pointer register (fp) so that
    # we can use the address of loc_tuple.
    let (__fp__, _) = get_fp_and_pc()

    check_solution(
        loc_list=cast(&loc_tuple, Location*),
        tile_list=cast(&tiles, felt*),
        steps=4
    )

    return ()
end