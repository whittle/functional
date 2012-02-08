require 'active_record'
require 'functional/active_record/calculated_attribute'
require 'spec_helper'

ActiveRecord::Base.establish_connection $test_db
ActiveRecord::Migration.verbose = false

# Fake and OtherFake are example classes intended to demonstrate both
# the public interface and inner workings of
# ActiveRecord::CalculatedAttribute. Silly names are used to avoid the
# cognitive overhead of thinking about a useful class at the same
# time. More driven examples can be found in the
# ActiveRecord::CalculatedAttribute module itself.
class Fake < ActiveRecord::Base
  def self.schema
    lambda do |t|
      t.boolean :automatic
      t.integer :foo
      t.integer :bar
      t.integer :baz
      t.references :other_fake
    end
  end

  include ActiveRecord::CalculatedAttribute
  calculated_attribute(:foo) { 2 }
  calc_attr(:bar) { |fake| fake.foo + 3 }
  calc_attr(:baz) { bar / 5 }
  belongs_to :other_fake
  calculated_attribute(:other_fake) { OtherFake.new :qux => 8 }
end

class OtherFake < ActiveRecord::Base
  def self.schema
    lambda { |t| t.integer :qux }
  end

  include ActiveRecord::CalculatedAttribute
end

module ActiveRecord
  describe CalculatedAttribute do
    before(:all) { Migration.create_table :fakes, :force => true, &Fake.schema }
    before(:all) { Migration.create_table :other_fakes, :force => true, &OtherFake.schema }
    after(:all) { Migration.drop_table :fakes }
    after(:all) { Migration.drop_table :other_fakes }

    context 'when manual' do
      subject { Fake.new :automatic => false }
      its(:foo) { should be_nil }
      its(:bar) { should be_nil }
      its(:other_fake) { should be_nil }
    end

    context 'when automatic' do
      subject { Fake.new :automatic => true }
      its(:automatic) { should be_true }
      its(:foo) { should == 2 }
      its(:bar) { should == 5 }
      its(:baz) { should == 1 }
      it { subject.other_fake.qux.should == 8 }

      context 'with foo already set' do
        before { subject.foo = 13 }
        its(:foo) { should == 13 }
        its(:bar) { should == 16 }
        its(:baz) { should == 3 }
      end

      it 'should store the attribute' do
        subject.foo.should == 2
        subject.attributes.symbolize_keys[:foo].should == 2
      end
    end
  end
end
