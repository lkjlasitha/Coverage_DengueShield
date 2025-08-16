import { NextRequest, NextResponse } from 'next/server';

const BACKEND_URL = 'http://16.171.60.189:5000';

export async function GET(request: NextRequest) {
  try {
    console.log("this is getting called")
    const token = request.headers.get('authorization');
    
    if (!token) {
      return NextResponse.json(
        { message: 'Authorization token required' },
        { status: 401 }
      );
    }

    // Call external backend API
    const response = await fetch(`${BACKEND_URL}/appointments`, {
      method: 'GET',
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      }
    });

    const data = await response.json();

    if (!response.ok) {
      return NextResponse.json(
        { message: data.message || 'Failed to fetch appointments' },
        { status: response.status }
      );
    }

    return NextResponse.json(data, { status: 200 });

  } catch (error) {
    console.error('Appointments fetch error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function PUT(request: NextRequest) {
  try {
    const token = request.headers.get('authorization');
    const { referenceNum, status } = await request.json();
    
    if (!token) {
      return NextResponse.json(
        { message: 'Authorization token required' },
        { status: 401 }
      );
    }

    if (!referenceNum || !status) {
      return NextResponse.json(
        { message: 'Reference number and status are required' },
        { status: 400 }
      );
    }

    // Call external backend API to update appointment status
    const response = await fetch(`${BACKEND_URL}/appointments/${referenceNum}`, {
      method: 'PUT',
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ status })
    });

    const data = await response.json();

    if (!response.ok) {
      return NextResponse.json(
        { message: data.message || 'Failed to update appointment' },
        { status: response.status }
      );
    }

    return NextResponse.json(
      { message: 'Appointment updated successfully', data },
      { status: 200 }
    );

  } catch (error) {
    console.error('Appointment update error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
