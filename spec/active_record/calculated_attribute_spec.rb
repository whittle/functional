require 'active_record'
require 'functional/active_record/calculated_attribute'
require 'spec_helper'

ActiveRecord::Base.establish_connection $test_db
ActiveRecord::Migration.verbose = false

module ActiveRecord
  class ::Fake < Base
    def self.schema
      lambda do |t|
        t.boolean :automatic
        t.integer :foo
        t.integer :bar
        t.integer :baz
        t.references :other_fake
      end
    end

    include CalculatedAttribute
    calculated_attribute(:foo) { 2 }
    calc_attr(:bar) { |fake| fake.foo + 3 }
    calc_attr(:baz) { bar / 5 }
    belongs_to :other_fake
    calculated_attribute(:other_fake) { OtherFake.new :qux => 8 }
  end

  class ::OtherFake < Base
    def self.schema
      lambda { |t| t.integer :qux }
    end

    include CalculatedAttribute
  end

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
