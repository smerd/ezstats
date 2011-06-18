class StepwiseRegression
attr_accessor :dep_var, :output_file

	def initialize(base_dataset)
		puts "Output results to file?"
		@output_file = File.new("ezstats_output.txt", "w+") if gets.chomp == 'y'
		@base_dataset = base_dataset
	end
	
	def outputs(output_text)
		@output_file.puts(output_text) if @output_file
		puts output_text
	end
	
	def start_analysis
		@dep_var = get_dep_var
		output_model_vars
		min_model_size = get_min_model_size
		var_combos = get_var_combos(min_model_size)
		regression_pool = collect_regressions(var_combos)
		#insert here other methods to determine "best"
		best_regression = best_r2_regression(regression_pool)
		output_best_regression(best_regression)
	end
	
	def output_model_vars
		ind_vars = []
		outputs "Dependent Variable: #{@dep_var}"
		@base_dataset.fields.each do |var|
			ind_vars.push(var) unless var == @dep_var
		end
		outputs "Independent Variables: #{ind_vars.sort.join(', ')}"
	end

	def get_min_model_size
		puts "Enter the fewest number of independent variables you'll accept:"
		min_model_size = gets.chomp.to_i
		outputs "Minimum number of independent variables: #{min_model_size}"
		min_model_size
	end
	
	def get_dep_var
		puts "Choose your dependent variable by number from the list below (e.g. '3'):"
		puts_var_choices
		dep_var = @base_dataset.fields[gets.chomp.to_i - 1]	
	end
		
	def puts_var_choices
		counter = 1
		@base_dataset.fields.each do |variable|
			puts "#{counter}) #{variable}"
			counter += 1
		end
	end
	
	def get_var_combos(min_model_size)
		ind_vars = @base_dataset.fields
		combo_pool = []
		unique_var_counter = ind_vars.size
		until unique_var_counter == min_model_size do
			var_array_combos = ind_vars.combination(unique_var_counter).to_a
			var_array_combos.each do |combo|
				if combo.include?(@dep_var) then
				combo_pool.push(combo) 
				end
			end
			unique_var_counter -= 1
		end
		combo_pool
	end

	def collect_regressions(var_combo_pool)
		puts "Ok, we'll run and compare #{var_combo_pool.size} regressions. Here we go!\n\r"
		regression_pool = []
		var_combo_pool.each do |iteration_vars|
			dataset_iteration = @base_dataset.dup(iteration_vars)
			regression_iteration = Statsample::Regression.multiple(dataset_iteration, @dep_var)
			outputs "Running regression: #{regression_iteration.coeffs.keys.join(', ')}"
			outputs "Adjusted R2: #{regression_iteration.r2_adjusted.round(4)}"
			regression_pool.push(regression_iteration)
			puts "#{var_combo_pool.size - regression_pool.size} left to run...\n\r"
		end
		outputs "Total number of regressions run: #{regression_pool.size}"
		regression_pool
	end

	def best_r2_regression(regression_pool)
		best_regression = regression_pool[0]
		regression_pool.each do |regression|
			if regression.r2_adjusted > best_regression.r2_adjusted
				best_regression = regression
			end
		end
		best_regression
	end

	def output_best_regression(best_regression)
		outputs "Best model independent variables: #{best_regression.coeffs.keys.join(', ')} \n\r"
		outputs best_regression.summary
	end
end
	
	
