class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :template_path
      t.string :report_path
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
