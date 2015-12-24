# mruby-statemachine
A tiny State Machine for mruby

Example
=======

```ruby
class Fsm
  include StateMachine

  attr_reader :started, :ended

  def initialize
    @started, @ended = false, false
  end

  state :start, to: [:hello, :end] do
    @started = true
  end

  state :hello, to: [:end]

  state :end, to: [] do
    @ended = true
    @started = false
  end
end

fsm = Fsm.new
fsm.transition :start
fsm.state.name == :start
fsm.started == true
fsm.transition :hello
fsm.state.name == :hello
fsm.transition :end
fsm.state.name == :end
fsm.ended == true
fsm.started == false
```
