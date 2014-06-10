# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Carnival::KlassService do

  describe "#relation?" do
    
    context "state and cities" do
      it "should return true" do
        klass_service = Carnival::KlassService.new Admin::State
        klass_service.relation?(:cities).should be_true
      end
    end
    
    context "city and state" do
      it "should return true" do
        klass_service = Carnival::KlassService.new Admin::City
        klass_service.relation?(:state).should be_true
      end
    end

    context "job and country" do
      it "should return false" do
        klass_service = Carnival::KlassService.new Admin::Job
        klass_service.relation?(:country).should be_false
      end
    end

  end


  describe "#is_a_belongs_to_relation?" do
  
    context "state and cities" do
      it "should return false" do
        klass_service = Carnival::KlassService.new Admin::State
        klass_service.is_a_belongs_to_relation?(:cities).should be_false
      end
    end

    context "city and state" do
      it "should return true" do
        klass_service = Carnival::KlassService.new Admin::City
        klass_service.is_a_belongs_to_relation?(:state).should be_true
      end
    end
  end

end
