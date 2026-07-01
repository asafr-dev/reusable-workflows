import { describe, it, expect } from 'vitest';
import { add } from './util';

describe('add', () => {
  it('adds', () => {
    expect(add(1, 2)).toBe(3);
  });
});
