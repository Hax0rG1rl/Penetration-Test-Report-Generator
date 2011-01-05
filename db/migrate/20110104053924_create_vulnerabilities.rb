class CreateVulnerabilities < ActiveRecord::Migration
  def self.up
    create_table :vulnerabilities do |t|
      t.string :title
      t.string :host
	  t.text :description
	  t.text :resolution
	  t.string :CVE
	  t.string :CWE	
	  t.references :report
      t.timestamps
    end
  end

  def self.down
    drop_table :vulnerabilities
  end
end
