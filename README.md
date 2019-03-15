# Guided Interactor

Guided Interactor is a spin-off from the [interactor](https://github.com/collectiveidea/interactor) gem. The Interactor 
Design Pattern allows us to build simple, single-purpose objects that move the business logic away from controllers and 
models. However, it also has some downsides, with the biggest pain point for me being the "Black Box Effect" 
with `context` - you never know what goes in or what comes out.

```
# Typical interactor:

class Foo
  include Interactor

  def call
    context.message = "#{context.greeting} #{context.name.capitalize}!"
  end
end

Foo.call(greeting: "Hello", name: "Waldo")
=> #<Interactor::Context greeting="Hello", name="Waldo", message="Hello Waldo!">

Foo.call(greeting: "Hi")
NoMethodError: undefined method `capitalize' for nil:NilClass
```

Guided Interactor is trying to fill the gap by providing more flexibility and clarity. Previously we have agreed to use 
`delegate :foo, to: :context` on two separate lines to define parameters expected and parameters that are set inside the 
interactor. This gem introduces 3 additional methods: `expects`, `expects!` and `provides`:

```
class MyInteractor
  include GuidedInteractor

  expects :foo
  expects! :bar
  provides :waldo

end
```

`expects` and `provides` are aliases and simply delegate the specified parameters to the context. `expexts!` does the same,
but adds a before hook that fails the context if any of the parameters is missing. The example above could then be rewritten
like this:

```
# Guided interactor:

class Foo
  include GuidedInteractor
  
  expects :greeting
  expects! :first_name, :last_name
  provides :message

  def call
    context.message = "#{greeting} #{first_name.capitalize} #{last_name.capitalize}!"
    puts message
  end
end

Foo.call(greeting: "Hello", first_name: "Waldo", last_name: "smith")
Hello Waldo Smith!
=> #<GuidedInteractor::Context greeting="Hello", first_name="Waldo", last_name="smith", message="Hello Waldo Smith!">

result = Foo.call(greeting: "Hi")
=> #<GuidedInteractor::Context greeting="Hi">
result.success?
=> false

Foo.call!(greeting: "Hi", first_name: 'John')
GuidedInteractor::Failure: #<GuidedInteractor::Context greeting="Hi", first_name="John">
```

## Future plans
In the future, there are plans to add further guidance to guided interactors, including more validations, defaults and error handling.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
