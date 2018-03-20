defmodule LoggerLager do
  use GenEvent

  @moduledoc """
  A `lager` backend for `Logger`.
  """

  @sink :lager_event
  @truncation_size 4096

  def init(__MODULE__) do
    {:ok, nil}
  end

  def handle_call({:configure, _opts}, state) do
    {:ok, :ok, state}
  end

  def handle_event({_level, gl, _event}, state) when node(gl) != node() do
    {:ok, state}
  end
  def handle_event({level, _gl, {Logger, message, _timestamp, metadata}}, state) do
    :lager.dispatch_log(@sink, to_lager_level(level), format_metadata(metadata),
      '~ts', [message], @truncation_size, :safe)
    {:ok, state}
  end

  defp to_lager_level(:warn), do: :warning
  defp to_lager_level(level), do: level

  defp format_metadata(md) do
    Enum.reduce(md, [], fn
      ({:file, _}, acc) -> acc
      ({key, val}, acc) -> [{key, format_metadata_value(val)} | acc]
    end)
  end

  defp format_metadata_value(pid) when is_pid(pid) do
    :erlang.pid_to_list pid
  end
  defp format_metadata_value(ref) when is_reference(ref) do
    '#Ref' ++ rest = :erlang.ref_to_list(ref)
    rest
  end
  defp format_metadata_value(atom) when is_atom(atom) do
    case Atom.to_string(atom) do
      "Elixir." <> rest -> rest
      binary -> binary
    end
  end
  defp format_metadata_value(other), do: other
end
