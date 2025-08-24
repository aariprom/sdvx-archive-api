import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { StatService } from './stat.service';
import { GetUser } from '../../common/decorators/get-user.decorator';
import type { JwtUser } from '../../common/types/auth-request';

@UseGuards(AuthGuard('jwt'))
@Controller('stats')
export class StatController {
  constructor(private svc: StatService) {}

  @Get('me/volforce')
  vfTimeline(
    @GetUser() user: JwtUser,
    @Query('mode') mode: 'perplay' | 'cumulative' = 'perplay',
  ) {
    return this.svc.vfTimeline(user.userId, mode);
  }
}
