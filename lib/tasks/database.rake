# encoding: UTF-8
# frozen_string_literal: true

Rake::Task['db:migrate'].enhance do
  Rake::Task['db:seed_fu'].invoke
end

Rake::Task['db:schema:load'].enhance do
  Rake::Task['db:seed_fu'].invoke
end
