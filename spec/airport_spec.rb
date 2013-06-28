require 'airport'
require 'plane'
 
# A plane currently in the airport can be requested to take off.
#
# No more planes can be added to the airport, if it's full.
# It is up to you how many planes can land in the airport and how that is impermented.
#
# If the airport is full then no planes can land
describe Airport do
  let(:airport) { Airport.new }
  
  context 'taking off and landing' do
  ###this test was changed to include stub for random weather, i.e. it must be sunny
    it 'a plane can land' do
        plane = double :plane
        plane.should_receive(:land!)
        airport.stub(:random_number).and_return(10)
        airport.order_landing!(plane)
        airport.number_of_landed_planes.should eq 1
    end

 ###this test was also changed to include stub for random weather, i.e. it must be sunny   
    it 'a plane can take off' do
        plane = double :plane
        plane.should_receive(:take_off!)
        airport.stub(:random_number).and_return(10)
        airport.order_take_off!(plane)
        airport.number_of_landed_planes.should eq 0
    end

 
  end
  
  context 'traffic control' do
##added test for airport not full by default
  it "airport is not full by default" do
    airport.should_not be_full
  end

##added test for airport is full if capacity of 5 planes is reached
##capacity is hard coded as 5 planes (it's a small airport!)
  context "full airport" do
    let(:full_airport){ Airport.new [:plane, :plane, :plane, :plane, :plane] }
      
      it "airport is full if it is at capacity, i.e. has 5 planes" do
        full_airport.should be_full
      end
      
      it 'plane cannot land if the airport is full' do
        plane = double :plane
        plane.should_not_receive(:land!)
        full_airport.should be_full
        full_airport.order_landing!(plane)
      end

  end #end of full airport context

    # Include a weather condition using a module.
    # The weather must be random and only have two states "sunny" or "stormy".
    # Try and take off a plane, but if the weather is stormy, the plane can not take off and must remain in the airport.
    # 
    # This will require stubbing to stop the random return of the weather.
    # If the airport has a weather condition of stormy,
    # the plane can not land, and must not be in the airport
    context 'weather conditions' do

      ###added test to say that the airport has a weather condition that is either sunny or stormy
      it "airport has a random weather condition which is sunny when the number is more than 2" do
        airport.stub(:random_number).and_return(10)
        airport.weather.should eq "sunny"
      end

      it "airport has a random weather condition which is stormy when the number returned is less than or equal to 2" do
        airport.stub(:random_number).and_return(0)
        airport.weather.should eq "stormy"
      end

      it 'a plane cannot take off when there is a storm brewing' do
        plane = double :plane
        plane.should_not_receive(:take_off!)
        airport.stub(:random_number).and_return(0)
        airport.order_take_off!(plane)
      end
      
      it 'a plane cannot land in the middle of a storm' do
        plane = double :plane
        plane.should_not_receive(:land!)
        airport.stub(:random_number).and_return(0)
        airport.order_landing!(plane)
      end
    end
  end
end
 
# When we create a new plane, it should have a "flying" status, thus planes can not be created in the airport.
#
# When we land a plane at the airport, the plane in question should have its status changed to "landed"
#
# When the plane takes of from the airport, the plane's status should become "flying"
describe Plane do
 
  let(:plane) { Plane.new }
  
  it 'has a flying status when created' do
    plane.status.should eq "flying"
  end
##it must be in the air when it is created, hence flying status and in_the_air is true
  it 'has a flying status when in the air' do
      plane.should be_in_the_air
      plane.status.should eq "flying"
  end

##added new test to see if plane can land
  it 'can land' do
    plane.land!
    plane.should_not be_in_the_air
    plane.status.should eq "landed"
  end

##created attr_accessor to assign in_the_air as false for this test
 context "landed plane" do
  let(:landed_plane){Plane.new}
  it 'can take off' do
    landed_plane.in_the_air = false
    landed_plane.should_not be_in_the_air
    landed_plane.take_off!
    landed_plane.in_the_air?.should be_true
  end
  
  it 'changes its status to flying after taking of' do
    landed_plane.in_the_air = false
    landed_plane.status.should eq "landed"
    landed_plane.take_off!
    landed_plane.status.should eq "flying"
  end
end

end #end of context landed plane
 
# grand final
# Given 6 planes, each plane must land. When the airport is full, every plane must take off again.
# Be careful of the weather, it could be stormy!
# Check when all the planes have landed that they have the right status "landed"
# Once all the planes are in the air again, check that they have the status of flying!
describe "The gand finale (last spec)" do
let(:airport){ Airport.new }
  it 'all planes can land and all planes can take off' do
    
    airport.stub(:random_number).and_return(10)  

    #plane1
    plane1 = Plane.new
    airport.order_landing!(plane1)
    plane1.status.should eq "landed"

    #plane2
    plane2 = Plane.new
    airport.order_landing!(plane2)
    plane2.status.should eq "landed"

    #plane3
    plane3 = Plane.new
    airport.order_landing!(plane3)
    plane3.status.should eq "landed"

    #plane4
    plane4 = Plane.new
    airport.order_landing!(plane4)
    plane4.status.should eq "landed"

    #plane5
    plane5 = Plane.new
    airport.order_landing!(plane5)
    plane5.status.should eq "landed"

  
    # plane6 -- can't land because the airport is full!
    plane6 = Plane.new
    airport.order_landing!(plane6)
    plane6.status.should_not eq "landed"

    #since airport is full, planes 1 to 5 will now take off
    ##TAKE OFF!

    #plane1
    airport.order_take_off!(plane1)
    plane1.status.should eq "flying"

     #plane2
    airport.order_take_off!(plane2)
    plane2.status.should eq "flying"

     #plane3
    airport.order_take_off!(plane3)
    plane3.status.should eq "flying"

     #plane4
    airport.order_take_off!(plane4)
    plane4.status.should eq "flying"

     #plane5
    airport.order_take_off!(plane5)
    plane5.status.should eq "flying"


    ##airport is no longer full, so plane6 can now land

    plane6 = Plane.new
    airport.order_landing!(plane6)
    plane6.status.should eq "landed"

    #and plane6 can also now take off
    airport.order_take_off!(plane6)
    plane6.status.should eq "flying"

  end
end