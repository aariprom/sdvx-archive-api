import {
  Injectable,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  constructor() {
    // todo: take this out as prismaConfig into config.ts
    super({
      datasources: {
        db: { url: process.env.DATABASE_URL }, // dotenvx로 주입된 값 사용
      },
      log:
        process.env.NODE_ENV === 'production'
          ? ['error'] // 운영은 에러만
          : ['warn', 'error'], // 개발은 경고+에러 (query는 필요할 때만)
    });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
