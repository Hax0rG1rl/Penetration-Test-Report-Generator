class AddReportidAndClientidtoReports < ActiveRecord::Migration
  def self.up
  	# this should make associating a report with a client or a user/author easier
  	add_column :reports, :user_id, :integer
  	add_column :reports, :client_id, :integer
  end

  def self.down
  	remove_column :reports, :user_id
  	remove_column :reports, :client_id  	
  end
end
