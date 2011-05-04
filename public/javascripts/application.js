/*
 * Copyright 2009 Huygens Instituut for the History of the Netherlands, Den Haag, The Netherlands.
 *
 * This file is part of New Women Writers.
 *
 * New Women Writers is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * New Women Writers is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with New Women Writers.  If not, see <http://www.gnu.org/licenses/>.
 */

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function deleteOneFromMany(objects,id) {
    new Ajax.Request(
       '/'+objects+'/destroy/'+id, {
         method : 'get',
         on200 : Effect.DropOut(objects+'_'+id),
         on500 : function(xhr){ alert(xhr.responseText) }
    });
  return false;
}

function addOneToMany(backtodestination) {
	eval("document.formnaam.backto"+backtodestination+".value='other'");
	document.formnaam.submit();
}

// adding a value to a helper table
// params: destination = helper table, returnobject = object to return to after creating the value
function addSubTable(destination, returnobject) {
	eval("document.formnaam.backto"+returnobject+".value='"+destination+"'");
	document.formnaam.submit();
}

// parked
function add_field(objectname, fieldname){
	var d=new Date();
	var thisid=d.getTime();

	var thisname=objectname+'[]['+fieldname+']';

	var input_and_button='<div id="'+thisid+'">';
	input_and_button+='<input type="text" name="'+thisname+'" class="input_field" />'; 
	//input_and_button+='<input type="button" class="input_button" value="Cancel" onclick="hideme(\''+thisid+'\')">';
	input_and_button+='</div>';

	var target=getObject('add_'+objectname);
	target.innerHTML+=input_and_button;

	alert();
}

// parked
function add_one(objectname, fieldname){
	var d=new Date();
	var thisid=d.getTime();

	var thisname=objectname+'[]['+fieldname+']';
	
	var input_and_button='<div id="'+thisid+'">';
	input_and_button+='<input type ="text" name="'+thisname+'" class="input_field" value="">'; 
	input_and_button+='<input type="button" id="'+thisid+'button" value="Cancel" onclick="cancel_me(\''+thisid+'\', \''+objectname+'\')">';
	input_and_button+='</div>';
	
	var targetname='add_'+objectname;
	var target=getObject(targetname);
	target.innerHTML+=input_and_button;
	
	var button=objectname+'button';
	getObject(button).style.display = "none";
	getObject(button).style.visibility = "hidden"; 
}   

// parked
function del_me(id){
	getObject(id).style.display = "none";
	getObject(id).style.visibility = "hidden"; 
	getObject(id).innerHTML='';
}   

// parked
function cancel_me(id, objectname){
	getObject(id).style.display = "none";
	getObject(id).style.visibility = "hidden"; 
	getObject(id).innerHTML='';
	var button=objectname+'button';
	toggle(getObject(button))
}   

function toggleSearch() {
	if (!document.formnaam.searchtoggle.undefined){
		obj=getObject('searchbox');
		obj.style.display = 'none' ;
		obj.style.visibility = 'hidden' ;
		if (document.formnaam.searchtoggle.value == 'on'){
			obj.style.display = 'block' ;
			obj.style.visibility = 'visible';		
		}
	}
}

function onoff(id){
	obj=getObject(id);
	toggle(obj);
}

function searchbox(objects){
	new Ajax.Request(
       '/'+objects+'/searchbox/', {
         method : 'get',
         on200 : onoff('searchbox'),
         on500 : function(xhr){ alert(xhr.responseText) }
    });
}

function helpbox(objects, actions){
	if (objects == 'homepage'){
	new Ajax.Request(
		'/'+objects+'/'+actions+'/', {
		 methos : 'get',
		 on200 : onoff('homepagehelp'),
		 on500 : function(xhr){ alert(xhr.responseText) }
	});}
	else {
	new Ajax.Request(
		'/'+objects+'/'+actions+'/', {
		 methos : 'get',
		 on200 : onoff('help'),
		 on500 : function(xhr){ alert(xhr.responseText) }
	});
	}
}

function toggle(obj){
	obj.style.display = obj.style.display =='block' ? 'none' : 'block';
	obj.style.visibility = obj.style.visibility == 'visible' ? 'hidden' : 'visible';
	document.formnaam.searchtoggle.value = document.formnaam.searchtoggle.value == 'on' ? 'off' : 'on';

}   

function getObject( obj ) {
  // Most browsers
  if ( document.getElementById ) {
    obj = document.getElementById( obj );
  // IE4
  } else if ( document.all ) {
    obj = document.all.item( obj );
  //Didn't work
  } else {
    obj = null;
  }
 return obj;
}