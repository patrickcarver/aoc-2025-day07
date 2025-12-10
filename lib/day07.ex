defmodule Day07 do
  def part1(file_name) do
    {start, splitters_by_row} = tachyon_manifold_data(file_name)
    beams = MapSet.new([start])

    count_beam_splits(splitters_by_row, beams, 0)
  end

  def part2(file_name) do
    {start, splitters_by_row} = tachyon_manifold_data(file_name)
    beams = %{start => 1}

    count_timelines(splitters_by_row, beams)
  end

  defp count_timelines([], beams) do
    Enum.sum_by(beams, fn {_key, value} -> value end)
  end

  defp count_timelines([row | rest], beams) do
    new_beams =
      Enum.reduce(beams, %{}, fn {{x, y}, count}, acc ->
        if {x, y + 1} in row do
          acc
          |> Map.update({x - 1, y + 2}, count, &(&1 + count))
          |> Map.update({x + 1, y + 2}, count, &(&1 + count))
        else
          Map.update(acc, {x, y + 2}, count, &(&1 + count))
        end
      end)

    count_timelines(rest, new_beams)
  end

  defp count_beam_splits([], _beams, num_splits) do
    num_splits
  end

  defp count_beam_splits([row | rest], beams, num_splits) do
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

    count_beam_splits(rest, new_beams, num_splits + additional_num_splits)
  end

  defp splitters_by_row(splitters) do
    splitters
    |> Enum.group_by(fn {_x, y} -> y end)
    |> Enum.to_list()
    |> Enum.sort_by(fn {row, _} -> row end)
    |> Enum.map(fn {_, list} -> list end)
  end

  defp tachyon_manifold_data(file_name) do
    file_name
    |> lines()
    |> tachyon_manifold()
    |> prep_data()
  end

  defp prep_data([{first_x, first_y} | splitters]) do
    {{first_x, first_y + 1}, splitters_by_row(splitters)}
  end

  defp tachyon_manifold(lines) do
    for {line, y} <- Enum.with_index(lines),
        {char, x} <- Enum.with_index(line),
        char != ".",
        into: [] do
      {x, y}
    end
  end

  defp lines(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.graphemes/1)
  end
end
