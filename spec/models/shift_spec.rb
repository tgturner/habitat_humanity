require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe '#destroy' do
    it 'removes all related ShiftEvents' do
      shift = FactoryGirl.create(:shift, :full)
      shift_event_ids = shift.shift_events.map(&:id)
      shift.destroy
      expect(ShiftEvent.where(id: shift_event_ids).to_a).to be_empty
    end
  end

  describe '#breaks_duration' do
    it 'raises an `IncompleteBreakError` if the volunteer forgot to sign back '\
       'in from their break' do
      shift = FactoryGirl.create :shift, :missing_break_return
      expect { shift.breaks_duration }.to raise_error \
        Shift::IncompleteBreakError
    end
  end
end
