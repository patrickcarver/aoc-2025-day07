defmodule Day07 do
  def part1(file_name) do
    [{start_x, start_y} | splitters] = load_tachyon_manifold(file_name)
    beams = MapSet.new([{start_x, start_y + 1}])

    splitters
    |> splitters_by_row()
    |> shine_beam(beams, 0)
  end

  def part2(file_name) do
    file_name
  end

  defp splitters_by_row(splitters) do
    splitters
    |> Enum.group_by(fn {_x, y} -> y end)
    |> Enum.to_list()
    |> Enum.sort_by(fn {row, _} -> row end)
    |> Enum.map(fn {_, list} -> list end)
  end

  defp shine_beam([], _beams, num_splits) do
    num_splits
  end

  defp shine_beam([row | rest], beams, num_splits) do
    down_one_set = beams |> Enum.map(fn {x, y} -> {x, y + 1} end) |> MapSet.new()
    row_set = MapSet.new(row)

    intersection = MapSet.intersection(down_one_set, row_set)
    additional_num_splits = MapSet.size(intersection)

    split_beams =
      intersection
      |> Enum.reduce(MapSet.new(), fn {x, y}, acc ->
        acc
        |> MapSet.put({x + 1, y + 1})
        |> MapSet.put({x - 1, y + 1})
      end)

    difference = MapSet.difference(down_one_set, row_set)
    unsplit_beams = difference |> Enum.map(fn {x, y} -> {x, y + 1} end) |> MapSet.new()
    new_beams = MapSet.union(split_beams, unsplit_beams)

    shine_beam(rest, new_beams, num_splits + additional_num_splits)
  end

  def load_tachyon_manifold(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.with_index()
    |> then(fn indexed_lines ->
      for {line, y} <- indexed_lines,
          {char, x} <- Enum.with_index(line),
          char != ".",
          into: [] do
        {x, y}
      end
    end)
  end
end
