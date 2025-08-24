import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { HealthModule } from './modules/health/health.module';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './modules/auth/auth.module';
import { UserModule } from './modules/user/user.module';
import { PrismaModule } from './modules/prisma/prisma.module';
import { PlayModule } from './modules/play/play.module';
import { ChartModule } from './modules/chart/chart.module';
import { StatModule } from './modules/stat/stat.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    HealthModule,
    AuthModule,
    UserModule,
    PlayModule,
    ChartModule,
    StatModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
