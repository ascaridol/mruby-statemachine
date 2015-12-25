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
  assert_false(fsm.started)
  assert_false(fsm.ended)
  assert_nothing_raised { fsm.transition(:start) }
  assert_equal(:start, fsm.state)
  assert_true(fsm.started)
  assert_raise(ArgumentError) { fsm.transition(:nonexistant) }
  assert_nothing_raised { fsm.transition(:hello) }
  assert_equal(:hello, fsm.state)
  assert_nothing_raised { fsm.transition(:end) }
  assert_equal(:end, fsm.state)
  assert_true(fsm.ended)
  assert_false(fsm.started)
  assert_raise(ArgumentError) { fsm.transition(:start) }
end
