import { describe, it, expect } from 'jest-without-globals';

const handle = require('./index');

describe('Entrypoint', () => {
  it('returns with json', () => {
    handle.handler({}, {}, (tmp, req) => {
      expect(req.body).toBe('{"text": "Thanks!"}');
    })
  });
});
