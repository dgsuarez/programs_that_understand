# This couple of macros allow for DRYness when defining a state machine.  The
# code has several problems at the very least it's hard to test and hard to
# understand.

macro initial_state(initial_state)
  @@transitions = [] of {Symbol, Symbol}
  @state = {{initial_state}}
end

macro add_state(state_name, state_action, transitions_to)
  {% for new_state in transitions_to %}
    @@transitions << { {{state_name}}, {{new_state}} }
  {% end %}

  def {{state_name.id}}?
    @state == {{state_name}}
  end

  def {{state_action.id}}
    transition_to_perform = { @state, {{state_name}} }
    return unless @@transitions.includes?(transition_to_perform)
    @state = {{state_name}}
  end

end

# We can solve both those problems by separating the actual logic from the
# macro code. These 2 classes can be tested independently.

class TransitionRules
  def initialize
    @valid_transitions = [] of {Symbol, Symbol}
  end

  def add_rules_for_state(from_state, to_states)
    to_states.each do |to_state|
      @valid_transitions << {from_state, to_state}
    end
  end

  def valid_transition?(from_state, to_state)
    @valid_transitions.includes?({from_state, to_state})
  end
end

class StateMachine

  def initialize(i_state : Symbol, rules : TransitionRules)
    @state = i_state
    @rules = rules
  end

  def transition_to(new_state)
    return unless @rules.valid_transition?(@state, new_state)
    @state = new_state
  end

  def in_state?(state)
    @state == state
  end
end

# And using them our macro is clearer.

macro initial_state(i_state)
  @@rules = TransitionRules.new
  @state = StateMachine.new({{i_state}}, @@rules)
end

macro add_state(state_name, state_action, transitions_to)
  @@rules.add_rules_for_state({{state_name}}, {{transitions_to}})

  def {{state_name.id}}?
    @state.in_state?({{state_name}})
  end

  def {{state_action.id}}
    @state.transition_to({{state_name}})
  end

end

# There's still problems with this code: How can I create a closed Door? How
# does inheritance work?  How many if door.open? will there be around my code?
# Be careful with this sort of code, iDSLs are bad ideas more often than not.

class Door
  initial_state :open

  add_state :open, :open, [:closed]
  add_state :closed, :close, [:open, :sealed]
  add_state :sealed, :seal, [] of Symbol
end

door = Door.new

p door.open? # true
p door.closed? # false
door.seal
p door.sealed? # false
door.close
door.seal
p door.sealed? # true
door.close
p door.closed? # false
