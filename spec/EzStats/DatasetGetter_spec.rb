require 'spec_helper'

class DatasetGetter
	
	describe DatasetGetter do
		
		before :each do
			@dataset_getter = DatasetGetter.new
		end
		
		it "should hold an original dataset object with the class 'Statsample Dataseobject'" do
			@dataset_getter.original_dataset.class.should == Statsample::Dataset
		end
	
		it 'the test dataset it produces should have three fields' do
			@dataset_getter.original_dataset.fields.count.should == 5
		end	
	end
end