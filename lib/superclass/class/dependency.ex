defmodule Superclass.Class.Dependency do

  use Superclass.Utility.Attribute
  use Quark

  defmacro __using__(_) do
    quote do
      alias   unquote(__MODULE__)
      require unquote(__MODULE__)

      unquote(__MODULE__).set_up
    end
  end

  @keyword :extend

  defmacro set_up do
    quote do
      Attribute.register(unquote(@keyword), accumulate: true)
    end
  end

  defmacro extend(parent_class) do
    quote do
      use unquote(parent_class)
      Attribute.set(unquote(@keyword), as: unquote(parent_class))
    end
  end

  defmacro run do
    quote do
      unquote(__MODULE__).create_dependencies_meta
      unquote(__MODULE__).create_use_dependencies
    end
  end

  def create_dependencies_meta do
    quote do
      def __DEPENDENCIES__ do
        __MODULE__
        |> Attribute.get(unquote(@keyword))
        |> Enum.map(Utility.Module.to_protocol <~> Protocol.assert_impl!)
      end
    end
  end

  def create_use_dependencies do
    quote do
      __DEPENDENCIES__
      |> Enum.map(&(Kernel.use(&1, :class)))
      |> unquote_splicing
    end
  end
end
