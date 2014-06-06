/**
 * ...
 * @author MW
 */

package com.exploringlines.gale.apps.datastructures;

class DLinkedListCell<T> implements haxe.rtti.Generic {
	public var elt : T;
	public var next : DLinkedListCell<T>;
	public var prev : DLinkedListCell<T>;
	public function new(elt, next, prev) { 
		this.elt = elt; 
		this.next = next;
		this.prev = prev;
	}
}

/**
 * A doubly-linked list of elements.
 */
class DLinkedList<T> implements haxe.rtti.Generic {

	public var head : DLinkedListCell<T>;
	public var tail : DLinkedListCell<T>;
	public var count(getCount, null):Int;

	/**
	 * Creates a new empty list.
	 */
	public function new() {
		count = 0;
	}

	/**
	 *	Add an element at the head of the list.
	 */
	public inline function add( item : T ) {
		head = new DLinkedListCell<T>(item, head, null);
		if (head.next != null) {
			head.next.prev = head;
		} else if (tail == null) {
			tail = head;
		}
	}

	/**
	 *	Returns the first element of the list, or null
	 *	if the list is empty.
	 */
	public inline function first() : Null<T> {
		return if( head == null ) null else head.elt;
	}

	/**
	 *	Tells if a list is empty.
	 */
	public inline function isEmpty() : Bool {
		return (head == null);
	}

	/**
	 *	Remove the first element that is [== v] from the list.
	 *	Returns [true] if an element was removed, [false] otherwise.
	 */
	public function remove( v : T ):Null<T> {
		var prev:DLinkedListCell<T> = null;
		var l = head;
		while( l != null ) {
			if( l.elt == v ) {
				if( prev == null ) {
					head = l.next;
					if (head != null) {
						head.prev = null;
					} else {
						tail = null;
					}
				} else {
					prev.next = l.next;
					if (l.next != null) {
						l.next.prev = prev;
					}
					if (tail == l) {
						tail = prev;
					}
				}
				return l.elt;
			}
			prev = l;
			l = l.next;
		}
		return (null);
	}
	
	/**
	 * Removes the element that is v directly.
	 * @param	v	The element to remove.
	 * @return	Returns [true] if an element was removed, [false] otherwise.
	 */
	public function removeDirectly(v:DLinkedListCell<T>):Null<T> {
		if (v.next != null && v.prev != null) {
			v.next.prev = v.prev;
			v.prev.next = v.next;
			return v.elt;
		}
		if (v.next == null) {
			if (v.prev != null) {
				v.prev.next = null;
				tail = v.prev;
			} else {
				head = null;
				tail = null;
			}
			return v.elt;
		}
		if (v.prev == null) {
			if (v.next != null) {
				v.next.prev = null;
				head = v.next;
			} else {
				head = null;
				tail = null;
			}
		}
		
		return (null);
	}

	/**
	 *	Returns an iterator on the elements of the list.
	 */
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
	 *	Returns a displayable representation of the String.
	 */
	public function toString() {
		var a = new Array();
		var l = head;
		while( l != null ) {
			a.push(l.elt);
			l = l.next;
		}
		return "{"+a.join(",")+"}";
	}

	/**
	 * Counts the number of elements in the list.
	 * @return
	 */
	private inline function getCount():Int {
		var count:Int = 0;
		var i = head;
		while (i != null) {
			count++;
			i = i.next;
		}
		
		return count;
	}
}
