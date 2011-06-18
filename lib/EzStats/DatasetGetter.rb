class DatasetGetter
attr_accessor :original_dataset, :base_dataset

	def initialize
		@original_dataset = get_original_dataset
		selected_vars = convert_user_input_to_field_names(user_var_selections)
		@base_dataset = create_base_dateset(selected_vars)
	end
	
	def get_original_dataset
		puts "Choose your CSV file from the list below (e.g. '2'):"
		user_csv = get_csv_choices[gets.chomp.to_i - 1]
		original_dataset = Statsample::CSV.read('./../user_data/' + user_csv)
	end
	
	def get_csv_choices
		file_counter = 1
		csv_choices = []
		Dir.foreach("./../user_data/") do |file| 
			if file.include?('.csv') then
				puts "#{file_counter}) #{file}"
				csv_choices.push(file)
				file_counter += 1
			end
		end
		csv_choices
	end
	
	def create_base_dateset(selected_vars)
		if selected_vars == @original_dataset.fields then 
			base_dataset = @original_dataset
		else
			base_dataset = @original_dataset.dup(selected_vars)
		end
		base_dataset
	end
		
	def user_var_selections
		puts "Select the variables for your model by number (e.g. '1, 2, 3') or type 'all'"
		puts_var_choices(@original_dataset)
		gets.chomp
	end
	
	def puts_var_choices(base_dataset)
		counter = 1
		base_dataset.fields.each do |variable|
			puts "#{counter}) #{variable}"
			counter += 1
		end
	end
	
	def convert_user_input_to_field_names(user_input)
		if user_input == 'all' then 
			selected_dataset_fields = @original_dataset.fields
		else
			selected_dataset_fields = []
			selection_array = user_input.split(', ')
			selection_array.each do |user_number|
				variable_number = user_number.to_i - 1
				selected_dataset_fields.push(@original_dataset.fields[variable_number])
			end
		end
		selected_dataset_fields
	end
end