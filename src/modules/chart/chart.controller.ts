import { Controller, Get, Param, Query } from '@nestjs/common';
import { ChartService } from './chart.service';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('Chart')
@Controller('charts')
export class ChartController {
  constructor(private svc: ChartService) {}

  @Get()
  list(
    @Query('q') q?: string,
    @Query('difficulty') difficulty?: string,
    @Query('level') level?: string,
    @Query('page') page = '1',
    @Query('pageSize') pageSize = '30',
  ) {
    return this.svc.list({
      q,
      difficulty,
      level: level ? Number(level) : undefined,
      page: Number(page),
      pageSize: Number(pageSize),
    });
  }

  @Get(':chartId/leaderboard')
  leaderboard(@Param('chartId') chartId: string, @Query('take') take = '50') {
    return this.svc.leaderboard(chartId, Number(take));
  }
}
