class RunTaskUpdateIsDebt < ActiveRecord::Migration[5.2]
  def change
    Rake::Task['tasks:update_is_debt'].invoke
  end
end
