import { NextRequest, NextResponse } from 'next/server';

const BACKEND_URL = 'http://16.171.60.189:5000';

export async function POST(request: NextRequest) {
  try {
    const { name, email, password, role = 'admin' } = await request.json();

    // Validate input
    if (!name || !email || !password) {
      return NextResponse.json(
        { message: 'Name, email, and password are required' },
        { status: 400 }
      );
    }

    // Validate government email
    const isGovEmail = email.toLowerCase().includes('.gov') || 
                     email.toLowerCase().includes('government') ||
                     email.toLowerCase().includes('dept') ||
                     email.toLowerCase().includes('ministry');

    if (!isGovEmail) {
      return NextResponse.json(
        { message: 'Only government email addresses are allowed' },
        { status: 400 }
      );
    }

    // Call external backend API
    const response = await fetch(`${BACKEND_URL}/signup`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        name,
        email,
        password,
        role
      })
    });

    const data = await response.json();

    if (!response.ok) {
      return NextResponse.json(
        { message: data.message || 'Signup failed' },
        { status: response.status }
      );
    }

    // Return success response
    return NextResponse.json({
      message: 'Admin account created successfully',
      user: data.user || { name, email, role }
    }, { status: 201 });

  } catch (error) {
    console.error('Signup error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
