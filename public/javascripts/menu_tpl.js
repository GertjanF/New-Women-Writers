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

/* --- geometry and timing of the menu --- */
var MENU_POS = new Array();

	// item sizes for different levels of menu
	MENU_POS['height']     = [2, 2];
	MENU_POS['width']      = [7, 12];

	// menu block offset from the origin:
	//  for root level origin is upper left corner of the page
	//  for other levels origin is upper left corner of parent item
	MENU_POS['block_top']  = [1, 2.5];
	MENU_POS['block_left'] = [44, -5];
	
	// offsets between items of the same level
	MENU_POS['top']        = [0, 2.5];
	MENU_POS['left']       = [7.2, 0];

	// time in milliseconds before menu is hidden after cursor has gone out
	// of any items
	MENU_POS['hide_delay'] = [200, 100];

/* --- dynamic menu styles ---
note: you can add as many style properties as you wish but be not all browsers
are able to render them correctly. The only relatively safe properties are
'color' and 'background'.
*/

var MENU_STYLES = new Array();

	// default item state when it is visible but doesn't have mouse over
	MENU_STYLES['onmouseout'] = [
		'background', ['#F8F5EE', '#F8F5EE'],
		'color', ['#B36B00', '#B36B00'],
	];

	// state when item has mouse over it
	MENU_STYLES['onmouseover'] = [
		'background', ['#ffffff', '#ffffff'],
		'color', ['#000000', '#000000'],
	];

	// state when mouse button has been pressed on the item
	MENU_STYLES['onmousedown'] = [
		'background', ['#DAD1B4', '#DAD1B4'],
		'color', ['#000000', '#000000'],
	];
	
