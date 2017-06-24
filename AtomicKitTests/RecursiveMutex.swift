/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2017 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @file        RecursiveMutex.swift
 * @copyright   (c) 2017, Jean-David Gadina - www.xs-labs.com
 */

import XCTest
import AtomicKit
import STDThreadKit

class RecursiveMutexTest: XCTestCase
{
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testLock_SameThread()
    {
        let m = try? RecursiveMutex()
        
        XCTAssertNotNil( m )
        XCTAssertTrue( m!.tryLock() )
        
        m!.unlock()
    }
    
    func testMultipleLock_SameThread()
    {
        let m = try? RecursiveMutex()
        
        XCTAssertNotNil( m )
        XCTAssertTrue( m!.tryLock() )
        XCTAssertTrue( m!.tryLock() )
        
        m!.unlock()
        m!.unlock()
    }
    
    func testLock_DifferentThreads()
    {
        let m = try? RecursiveMutex()
        var b = false
        
        XCTAssertNotNil( m )
        XCTAssertTrue( m!.tryLock() )
        
        let _ = try? STDThread
        {
            b = m!.tryLock()
            
            if( b )
            {
                m!.unlock()
            }
        }
        .join()
        
        XCTAssertFalse( b )
        m!.unlock()
        
        let _ = try? STDThread
        {
            b = m!.tryLock()
            
            if( b )
            {
                m!.unlock()
            }
        }
        .join()
        
        XCTAssertTrue( b )
    }
}
