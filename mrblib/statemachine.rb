module StateMachine
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def states
      @states ||= {}
    end

    def state(name, transitions = nil, &block)
      states[name] = State.new(name, transitions, &block)
      define_method("#{name}?") do
        @state == name
      end
      self
    end
  end

  attr_reader :state, :current_state

  def transition(new_state)
    return if @current_state && @current_state.name == new_state

    unless next_state = self.class.states[new_state]
      raise ArgumentError, "state #{new_state} doesn't exist"
    end
    if @current_state
      if @current_state.valid_transition?(new_state)
        next_state.call(self)
      else
        raise ArgumentError, "cannot transition to #{new_state}"
      end
    else
      next_state.call(self)
    end

    @state = new_state
    @current_state = next_state
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
