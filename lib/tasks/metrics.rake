# encoding: UTF-8
# frozen_string_literal: true

require 'metric_fu'
MetricFu::Configuration.run do |config|
  config.rcov[:test_files] = ['spec/**/*_spec.rb']
  config.rcov[:rcov_opts] << '-Ispec' # Needed to find spec_helper
  config.metrics -= [:rails_best_practices]
end
