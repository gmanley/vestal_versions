require 'spec_helper'

describe VestalVersions::Creation do
  let(:name){ 'Steve Richert' }
  subject(:user) { User.create(:name => name) }

  context 'the number of versions' do

    it 'should equal zero' do
      expect(user.versions.count).to eq(0)
    end

    context 'with :initial_version option' do
      before do
        User.prepare_versioned_options(:initial_version => true)
      end

      it 'should equal one' do
        expect(user.versions.count).to eq(1)
      end
    end

    it 'does not increase when no changes are made in an update' do
      expect {
        subject.update_attribute(:name, name)
      }.to change{ subject.versions.count }.by(0)
    end

    it 'does not increase when no changes are made before a save' do
      expect{ subject.save }.to change{ subject.versions.count }.by(0)
    end

    it 'increases by one after an update' do
      expect{
        subject.update_attribute(:last_name, 'Jobs')
      }.to change{ subject.versions.count }.by(1)
    end

    it 'increases multiple times after multiple updates' do
      expect{
        subject.update_attribute(:last_name, 'Jobs')
        subject.update_attribute(:first_name, 'Brian')
      }.to change{ subject.versions.count }.by(2)
    end

  end

  context "a created version's changes" do
    before do
      subject.update_attribute(:last_name, 'Jobs')
    end

    it 'does not contain Rails timestamps' do
      %w(created_at created_on updated_at updated_on).each do |timestamp|
        expect(subject.versions.last.changes.keys).not_to include(timestamp)
      end
    end

    it 'allows the columns tracked to be restricted via :only' do
      User.prepare_versioned_options(:only => [:first_name])
      subject.update_attribute(:name, 'Steven Tyler')

      expect(subject.versions.last.changes.keys).to eq(['first_name'])
    end

    it 'allows specific columns to be excluded via :except' do
      User.prepare_versioned_options(:except => [:first_name])
      subject.update_attribute(:name, 'Steven Tyler')

      expect(subject.versions.last.changes.keys).not_to include('first_name')
    end

    it "prefers :only to :except" do
      User.prepare_versioned_options(:only => [:first_name],
        :except => [:first_name])
      subject.update_attribute(:name, 'Steven Tyler')

      expect(subject.versions.last.changes.keys).to eq(['first_name'])
    end
  end

  context 'first version' do
    it 'is number 2 after an update' do
      subject.update_attribute(:last_name, 'Jobs')
      expect(subject.versions.first.number).to eq(2)
    end

    it "is number 1 if :initial_version is true" do
      User.prepare_versioned_options(:initial_version => true)
      expect(subject.versions.first.number).to eq(1)
    end
  end

end
