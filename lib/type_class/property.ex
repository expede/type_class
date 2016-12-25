defmodule TypeClass.Property do
  alias TypeClass.Utility.Module

  defmacro ensure! do
    quote do
      case Code.ensure_loaded(__MODULE__.Property) do
        {:module, _prop_submodule} -> nil

        {:error, :nofile} ->
          raise TypeClass.Property.Undefined.new(__MODULE__)
      end
    end
  end

  def run!(datatype, class, prop_name, times \\ 1) do
    property_module = Module.append(class, Property)
    example_module = Module.append(TypeClass.Property.Generator, datatype)

    Stream.repeatedly(fn ->
      unless apply(property_module, prop_name, [example_module.generate(nil)]) do
        datatype
        |> TypeClass.Property.FailedCheck.new(class, prop_name)
        |> raise
      end
    end)
    |> Stream.take(times)
    |> Enum.to_list
  end
end
