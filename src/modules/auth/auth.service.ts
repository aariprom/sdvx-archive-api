import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as argon2 from 'argon2';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwt: JwtService,
  ) {}

  async register(email: string, playerName: string, password: string) {
    // 1) check if there are existing user with same email
    const exists = await this.prisma.user.findUnique({ where: { email } });
    // 2) if then, do not allow registration
    // todo: frontend should handle this gracefully
    if (exists) throw new BadRequestException('Email already in use');
    else {
      // 3) else, create user
      const user = await this.prisma.user.create({
        data: { email, playerName, passwordHash: await argon2.hash(password) },
        select: { id: true, email: true, playerName: true, createdAt: true },
      });
      return { user, accessToken: await this.sign(user.id, user.email) };
    }
  }

  async login(email: string, password: string) {
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user || !(await argon2.verify(user.passwordHash, password))) {
      throw new UnauthorizedException('Invalid credentials');
    }
    return {
      user: {
        id: user.id,
        email: user.email,
        playerName: user.playerName,
        createdAt: user.createdAt,
      },
      accessToken: await this.sign(user.id, user.email),
    };
  }

  // return jwt access token
  private sign(sub: string, email: string) {
    return this.jwt.signAsync({ sub, email });
  }
}
