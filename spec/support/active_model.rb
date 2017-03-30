# encoding: utf-8
# frozen_string_literal: true

shared_examples_for 'ActiveModel' do
  include ActiveModel::Lint::Tests

  # to_s is to support ruby-1.9
  ActiveModel::Lint::Tests.public_instance_methods
                          .map(&:to_s).grep(/\Atest/).each do |m|
    example m.tr('_', ' ') do
      send m
    end
  end

  let(:model) { subject }
end
