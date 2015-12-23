module StateMachine
  def self.included(klass)
    klass.send :extend, ClassMethods
  end

  module ClassMethods
    def states
      @states ||= {}
    end

    def state(name, transitions = nil, &block)
      states[name] = State.new(name, transitions, &block)
      self
    end
  end

  attr_reader :state

  def transition(new_state, &block)
    if @state && @state.name == new_state
      self.instance_eval(&block) if block
      return
    end

    unless next_state = self.class.states[new_state]
      raise ArgumentError, "state #{new_state} doesn't exist"
    end
    if @state
      if @state.valid_transition?(new_state)
        self.instance_eval(&block) if block
        next_state.call(self)
      else
        raise ArgumentError, "cannot transition to #{new_state}"
      end
    else
      self.instance_eval(&block) if block
      next_state.call(self)
    end

    @state = next_state
    self
  end

  class State
    attr_reader :name

    def initialize(name, transitions, &block)
      @name = name
      @transitions = transitions[:to] if transitions
      @block = block
    end

    def call(obj)
      obj.instance_eval(&@block) if @block
    end

    def valid_transition?(new_state)
      return true unless @transitions

      @transitions.include? new_state
    end
  end
end
