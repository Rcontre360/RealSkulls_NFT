export const shouldThrowAsync = async (promise: Promise<unknown>, message = "") => {
  try {
    await promise;
  } catch (err) {
    return;
  }
  assert.fail(message);
};


