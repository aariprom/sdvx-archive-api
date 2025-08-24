import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { PlayService } from './play.service';
import { CreatePlayDto } from './dto/create-play.dto';
import { GetUser } from '../../common/decorators/get-user.decorator'; // req.user 꺼내는 데코레이터
import type { JwtUser } from '../../common/types/auth-request';
import { ApiOperation, ApiTags } from '@nestjs/swagger'; // import type

@ApiTags('Play')
@UseGuards(AuthGuard('jwt'))
@Controller('play')
export class PlayController {
  constructor(private svc: PlayService) {}

  @ApiOperation({ summary: 'create play' })
  @Post()
  create(@GetUser() user: JwtUser, @Body() dto: CreatePlayDto) {
    return this.svc.create(user.userId, dto);
  }

  @ApiOperation({ summary: 'return every play of user, with page' })
  @Get('me')
  listMine(
    @GetUser() user: JwtUser,
    @Query('page') page = '1',
    @Query('pageSize') pageSize = '30',
  ) {
    return this.svc.listMine(user.userId, Number(page), Number(pageSize));
  }
}
