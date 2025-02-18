/*
 * 	@(#)%Portal Version: PinSimplePtrTypeWrapper.h:RWSmod7.3.1Int:1:2007-Sep-12 23:54:13 %
 *
 *	Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 * 
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _PinSimplePtrTypeWrapper_H_
#define _PinSimplePtrTypeWrapper_H_

#ifndef    _PinAnyTypeWrapper_H_
  #include "PinAnyTypeWrapper.h"
#endif

extern void throwNullPointerException();

template < class T>
class PCMCPP_CLASS PinSimplePtrTypeWrapper : public PinAnyTypeWrapper {
public:
#if defined(PCMCPP_CONST_SAFE)
	const T get() const
	{
	  	void* vp = const_cast< void* >(PinAnyTypeWrapper::get());
		return const_cast< T >(static_cast< T >(vp));
	}
#else
	T get() const
	{
	  	void *vp = const_cast< void* >(PinAnyTypeWrapper::get());
		return static_cast< T >(vp);
	}
#endif
	T get()
	{
		return static_cast< T >(PinAnyTypeWrapper::get());
	}

#if defined(PCMCPP_CONST_SAFE)
	const T value() const
	{
		const T val = get();
		if (!val) {
			throwNullPointerException();
		}
		return val;
	}
#else
	T value() const
	{
		T val = get();
		if (!val) {
			throwNullPointerException();
		}
		return const_cast< T >(val);
	}
#endif

	T value()
	{
		T val = get();
		if (!val) {
			throwNullPointerException();
		}
		return val;
	}
public:	
	// The following methods are for use by PinAnyBase< T,U> only.
	// Ideally, without templates, these would be either embededded inside
	// PinAnyBase or this would declare PinAnyBase to be a friend.
	PinSimplePtrTypeWrapper()
	{}
	void grab(T pointee, int owns)
	{
	  	PinAnyTypeWrapper::grab(pointee, owns);
	}
	void takeFrom(PinSimplePtrTypeWrapper< T> &other)
	{
		PinAnyTypeWrapper::takeFrom(other);
	}
	void copyFrom(const PinSimplePtrTypeWrapper< T> &other)
	{
		PinAnyTypeWrapper::copyFrom(other);
	}
	T release()
	{
		return static_cast< T >(PinAnyTypeWrapper::release());
	}
};

#endif /* _PinSimplePtrTypeWrapper_H_ */
