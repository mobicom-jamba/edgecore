import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email, password } = body;

    // Simple demo authentication
    if (email === 'admin@example.com' && password === 'password123') {
      const mockUser = {
        id: '1',
        email: 'admin@example.com',
        name: 'Admin User',
        role: 'user',
        createdAt: new Date().toISOString(),
      };

      const mockToken = 'demo-jwt-token-' + Date.now();

      return NextResponse.json({
        success: true,
        data: {
          token: mockToken,
          user: mockUser,
        },
        message: 'Login successful',
      });
    }

    return NextResponse.json(
      {
        success: false,
        message: 'Invalid credentials',
      },
      { status: 401 }
    );
  } catch (error) {
    return NextResponse.json(
      {
        success: false,
        message: 'Internal server error',
      },
      { status: 500 }
    );
  }
}
