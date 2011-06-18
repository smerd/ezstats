#testing stepwise operations
#Test data variables: "wawgt", "inc_grp", "hh_size", "mon_inc", "pufid"
require 'spec_helper'

describe StepwiseRegression do
	before(:all) do
		@base_dataset = Statsample::CSV.read('./sample_data/test_childcare.csv')
		@stepwise = StepwiseRegression.new(@base_dataset)
		@stepwise.dep_var = 'mon_inc'
		@ind_vars = ['wawgt', 'inc_grp', 'hh_size', 'pufid']
	end
	
	context 'When dep_var=mon_inc and all other test_childcare vars included' do
	
		describe "#get_var_combos" do
			it 'should collect 15 ind var combos when min model size is 1' do
				var_combos = @stepwise.get_var_combos(1)
				var_combos.size.should == 15
			end		
			
			it 'should collect 11 ind var combos when min model size is 2' do
				var_combos = @stepwise.get_var_combos(2)
				var_combos.size.should == 11
			end
		
			it 'should collect 5 ind var combos when min model size is 3' do
				var_combos = @stepwise.get_var_combos(3)
				var_combos.size.should == 5
			end
		end
	
	context 'When minium model size is 3 and dep_var=mon_inc'
		before(:all) do
			@var_combos = @ind_vars.combination(3).to_a
			@var_combo_pool = @var_combos.each {|combo| combo.push(@dep_var)}
		end

	#	describe "#collect_regressions" do
	#		it 'should return an array with X objects' do
	#			regression_pool = @stepwise.collect_regressions(@var_combo_pool)
	#			regression_pool.size.should == 5
	#		end
			
	#		it 'should hold arrays of Statsample regressions objects'
	#	end
		
	end
end