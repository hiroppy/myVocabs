'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;
////////
// priority 0 -> 1 -> 2(Max)

var wordSchema = new Schema({
  word: String,
  date: String,
  roughly: String,
  description: String,
  priority: String,
  tag: Array,
  accessCount: Number,
  close: Boolean
});

module.exports = mongoose.model('Thing', wordSchema);
