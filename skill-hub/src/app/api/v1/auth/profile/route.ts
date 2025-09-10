import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  try {
    const authHeader = request.headers.get('authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return NextResponse.json(
        {
          success: false,
          message: 'No token provided',
        },
        { status: 401 }
      );
    }

    const token = authHeader.substring(7);
    
    // Simple token validation (in real app, you'd verify JWT)
    if (token.startsWith('demo-jwt-token-')) {
      const mockUser = {
        id: '1',
        email: 'admin@example.com',
        name: 'Admin User',
        role: 'user',
        createdAt: new Date().toISOString(),
      };

      return NextResponse.json({
        success: true,
        data: {
          user: mockUser,
        },
      });
    }

    return NextResponse.json(
      {
        success: false,
        message: 'Invalid token',
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
