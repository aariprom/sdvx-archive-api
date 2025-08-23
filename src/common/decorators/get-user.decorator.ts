import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { JwtUser } from '../types/auth-request';

export const GetUser = createParamDecorator((_data, ctx: ExecutionContext) => {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
  const req = ctx.switchToHttp().getRequest();
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
  return req.user as JwtUser;
});
