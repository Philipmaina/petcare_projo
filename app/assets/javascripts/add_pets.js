// this first statement just says don't execute any of this jquery code until the DOM has fully loaded .
// all jquery code is placed inside the braces.


// $(document).ready(function(){ }) DAENT WORK WELL WITH TURBOLINKS
// NOTE TO FUTURE SELF!!!!!!! : READ ON THIS LATER
$(document).on('ready page:load', function() {

	pets = []; //this is an array in js can be array of anything  it is a global variable. in our case it will be an array of objects


	// ~~~~~~WE LISTEN FOR INTERACTION OF CLICKING ADD PET BUTTON~~~~

	$("#add_pet_button").click(function(){


		$(this).toggleClass("visibleness"); // toggleClass adds or removes classes from the element matched in the DOM in this case the add_pet_button for lowering the form. So the first time in , the visibleness class is added which makes the button invisible.
		// this is the object that caused the currently executing event handler to run.

		$("#add_pet").slideDown("slow"); //when page is loaded this section is hidden - so now we want it to show to allow petowner to add pets they own.
	});

	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



	// ~~~~~WE LISTEN FOR INTERACTION OF CLICKING CANCEL BUTTON~~~~~
	$("#close_form_btn").click(function(){

		$("#add_pet").slideUp("slow") ; //THIS HIDES THE FORM 

		$("#add_pet_button").toggleClass("visibleness"); //AND BECAUSE FORM IS HIDDEN WE CAN NOW SHOW ADD PETSBUTTON TO ALLOW USER TO RECLICK FOR FORM TO REDISPLAY IF THEY WANT.

	});
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



	// ___________BASIC SKELETON FOR ADDIN PETS TO TABLE_____________
	// ~~~~~~~~~~~~~WE LISTEN FOR FORM SUBMISSION~~~~~~~~~~~~~~~~~~~~
	$(".add-pets-form").submit( function(event) { //remember it is the form submitted not the button, so we select the form

		// usually when we submit a form the form data is submitted to server - this is a default behaviour. this is what happens when submit event is triggered. So we have to find a way to stop this default action. 
		// so we stop and intercept that normal action and perform our own custom stuff(we want our own code to be executed)
		event.preventDefault() ;

		// SO WE WANT TO GET THAT FORM DATA AND CREATE A ROW IN OUR TABLE

		var pet = {}; //empty object in js - remember this pet variable can only be accessed in this function that is attached to submit event

		// we can target the form elements in our form and get actual text or value from them using .val()
		pet.name = $("#add_pet input[name=name]").val();
		pet.type = $("#add_pet select[name=type]").val();
		pet.years = $("#add_pet input[name=years]").val();
		pet.gender = $("#add_pet select[name=gender]").val();
		

		// In JS we have truthy and falsy values that are usually evaluated using Boolean function.All values are truthy unless they have 0 , "" , null , undefined.

		if (pet.name) { //if pet.name has a string the value is truthy

			pets.push(pet); //the .push method adds new item to end of array

			// ------------dom manipulation , dom insertion inside---------
			//we concatenate to allow use of variable
			$("#pets").append("<tr class='warning'>" + "<td>" + pet.name + "</td>" + "<td>" + pet.type + "</td>" + "<td>" + pet.years + "</td>" + "<td>" + pet.gender + "</td>" + "<td class=' text-center '><a class='btn btn-xs remove-row' style='color: red ;'>x</a></td>" + "</tr>") ;

			//--------------erasing out values in fields---------------------

			// -----earlier in the normal action of submission the data in the fields was getting erased for us but sice we stop normal action now the values remain there even after submission so we need to chuck them.
			$("#add_pet input[name=name]").val(""); //we reset the values to nothing
			$("#add_pet input[name=years]").val("");


		}
		

	}) ;


	// _________________________________________________________________

	// ---------WHAT HAPPENS WHEN THAT SMALL X BUTTON IS CLICKED---------

	// we want to be able to remove that pet from the table(easy) and from our pets array.
	// ----------we are listening for a click of that small x-----------

	// the document.ready holds in the document the first version of the DOM which doesnt have the dynamically created stuff including the rows of our table that have the cancel button - so we have to find a way to take current version of DOM and now store it in document variable. therefore remember the first document won't know of a cancel button.
	// $(".remove-row").click(function() {
	// 	console.log("BUTTON X CLICKED");
	// }); 
	// the above wont work

	// we get current reading of DOM
	// the last parameter is just our event handler
	$(document).on("click" , ".remove-row" , function() {

		// this will be the a tag that caused this code to run
		// .closest() begins search with current element itself and travels up the DOM tree(like looking at parents and parent's parents) until it finds a match for the supplies selector and stops there. remember closest return zero object if nothing is found or one object which is the first object that will be seen. doesn't return many
		// .index() will return the position of the first element within the set of matched elements in relation to its siblings - so like first sibling which is first tr tag will be index 0 , second sibling if it exists which in our case will be second tr tag will be index 1
		var index_of_deleted_row = $(this).closest("tr").index() ;
		
		// we do parent() twice because the a tag is a grand child of tr tag we want to remove
		$(this).parent().parent().remove() ;

		pets.splice(index_of_deleted_row , 1) ; //the first parameter is the index at which we start removing items from then second parameter is the number of elements to remove. Therefore if array a = ["mat" ,"bat" , "cat" , "rat"] , a.splice(2,1) would remove "cat" , so a is now ["mat","bat","rat"]


	});
	// __________________________________________________________________


	// ~~~FINALLY WHEN USER IS SATISFIED WITH THE PETS AND WANT TO SAVE~~

	$("#submission_form_btn").click(function() {

		// JSON.stringify({ x: 5 }) == '{"x":5}'

		// without JSON.stringify you get this 
		// "petowner"=>{"pets"=>"[object Object],
		// [object Object],
		// [object Object]"}
		// because you are passing objects to a textfield
		// we should instead pass a string to the textfield
		$(".interested_input_field").val("")
		$(".interested_input_field").val(JSON.stringify(pets))




	});



}) ; 