class StateMachineTest
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

assert("StateMachine") do
  fsm = StateMachineTest.new
  assert_equal(false, fsm.started)
  assert_equal(false, fsm.ended)
  assert_nothing_raised { fsm.transition(:start) }
  assert_equal(:start, fsm.state.name)
  assert_equal(true, fsm.started)
  assert_raise(ArgumentError) { fsm.transition(:nonexistant) }
  assert_nothing_raised { fsm.transition(:hello) }
  assert_equal(:hello, fsm.state.name)
  assert_nothing_raised { fsm.transition(:end) }
  assert_equal(:end, fsm.state.name)
  assert_equal(true, fsm.ended)
  assert_equal(false, fsm.started)
  assert_raise(ArgumentError) { fsm.transition(:start) }
end
