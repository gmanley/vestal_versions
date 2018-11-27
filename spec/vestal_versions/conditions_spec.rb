require 'spec_helper'

describe VestalVersions::Conditions do
  shared_examples_for 'a conditional option' do |option|
    before do
      User.class_eval do
        def true; true; end
      end
    end

    it 'is an array' do
      expect(User.vestal_versions_options[option]).to be_a(Array)
      User.prepare_versioned_options(option => :true)
      expect(User.vestal_versions_options[option]).to be_a(Array)
    end

    it 'has proc values' do
      User.prepare_versioned_options(option => :true)
      User.vestal_versions_options[option].each{|i| expect(i).to be_a(Proc) }
    end
  end

  it_should_behave_like 'a conditional option', :if
  it_should_behave_like 'a conditional option', :unless

  context 'a new version' do
    let(:user) { User.create(:name => 'Steve Richert') }
    let!(:inital_count) { user.versions.count }

    before do
      User.class_eval do
        def true; true; end
        def false; false; end
      end
    end

    after do
      User.prepare_versioned_options(:if => [], :unless => [])
    end

    context 'with :if conditions' do
      context 'that pass' do
        before do
          User.prepare_versioned_options(:if => [:true])
          user.update_attribute(:last_name, 'Jobs')
        end

        it 'should create another version' do
          expect(user.versions.count).to eq(inital_count + 1)
        end
      end

      context 'that fail' do
        before do
          User.prepare_versioned_options(:if => [:false])
          user.update_attribute(:last_name, 'Jobs')
        end

        it 'should not create another version' do
          expect(user.versions.count).to eq(inital_count)
        end
      end
    end

    context 'with :unless conditions' do
      context 'that pass' do
        before do
          User.prepare_versioned_options(:unless => [:true])
          user.update_attribute(:last_name, 'Jobs')
        end

        it 'should not create another version' do
          expect(user.versions.count).to eq(inital_count)
        end
      end

      context 'that fail' do
        before do
          User.prepare_versioned_options(:unless => [:false])
          user.update_attribute(:last_name, 'Jobs')
        end

        it 'should create another version' do
          expect(user.versions.count).to eq(inital_count + 1)
        end
      end
    end

    context 'with :if and :unless conditions' do
      context 'that pass' do
        before do
          User.prepare_versioned_options(:if => [:true], :unless => [:true])
          user.update_attribute(:last_name, 'Jobs')
        end

        it 'should not create another version' do
          expect(user.versions.count).to eq(inital_count)
        end
      end

      context 'that fail' do
        before do
          User.prepare_versioned_options(:if => [:false], :unless => [:false])
          user.update_attribute(:last_name, 'Jobs')
        end

        it 'should not create another version' do
          expect(user.versions.count).to eq(inital_count)
        end
      end
    end
  end
end
