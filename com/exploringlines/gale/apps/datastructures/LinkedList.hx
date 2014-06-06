/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.datastructures;

class LinkedCell<T> {
	public var elt : T;
	public var next : LinkedCell<T>;
	public function new(elt,next) { this.elt = elt; this.next = next; }
}

/**
	A linked-list of elements. A different class is created for each container used in platforms where it matters
**/
class LinkedList<T> {

	public var head : LinkedCell<T>;

	/**
		Creates a new empty list.
	**/
	public function new() {
	}

	/**
		Add an element at the head of the list.
	**/
	public inline function add( item : T ) {
		head = new LinkedCell<T>(item,head);
	}
	
	/**
		Returns the first element of the list, or null
		if the list is empty.
	**/
	public inline function first() : Null<T> {
		return if( head == null ) null else head.elt;
	}

	/**
		Removes the first element of the list and
		returns it or simply returns null if the
		list is empty.
	**/
	public inline function pop() : Null<T> {
		var k = head;
		if( k== null )
			return null;
		else {
			head = k.next;
			return k.elt;
		}
	}

	/**
		Tells if a list is empty.
	**/
	public inline function isEmpty() : Bool {
		return (head == null);
	}

	/**
		Remove the first element that is [== v] from the list.
		Returns [true] if an element was removed, [false] otherwise.
	**/
	public function remove( v : T ) : Bool {
		var prev = null;
		var l = head;
		while( l != null ) {
			if( l.elt == v ) {
				if( prev == null )
					head = l.next;
				else
					prev.next = l.next;
				break;
			}
			prev = l;
			l = l.next;
		}
		return (l != null);
	}

	/**
		Returns an iterator on the elements of the list.
	**/
	public function iterator() : Iterator<T> {
		var l = head;
		return {
			hasNext : function() {
				return l != null;
			},
			next : function() {
				var k = l;
				l = k.next;
				return k.elt;
			}
		};
	}

	/**
		Returns a displayable representation of the String.
	**/
	public function toString() {
		var a = new Array();
		var l = head;
		while( l != null ) {
			a.push(l.elt);
			l = l.next;
		}
		return "{"+a.join(",")+"}";
	}

}
