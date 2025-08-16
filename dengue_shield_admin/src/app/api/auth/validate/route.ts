import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const authHeader = request.headers.get('authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return NextResponse.json(
        { message: 'No token provided' },
        { status: 401 }
      );
    }

    const token = authHeader.substring(7);

    // In a real app, you would properly validate the JWT token
    // For demo purposes, we're just checking if it starts with 'token_'
    if (!token.startsWith('token_')) {
      return NextResponse.json(
        { message: 'Invalid token' },
        { status: 401 }
      );
    }

    // In a real app, you would decode the JWT and verify expiration
    // For demo, we'll just return success
    return NextResponse.json({
      message: 'Token is valid',
      valid: true,
    });

  } catch (error) {
    console.error('Token validation error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
